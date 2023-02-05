// SETTING UP LOAD BALANCER TARGET GROUP
resource "aws_lb_target_group" "hmw-target-group" {
	name        = "hmw-alb-tg"
	port        = 80
	protocol    = "HTTP"
	vpc_id      = aws_vpc.hmw-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "target-group-att1" {
  target_group_arn = aws_lb_target_group.hmw-target-group.arn
  target_id        = aws_instance.web-server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target-group-att2" {
  target_group_arn = aws_lb_target_group.hmw-target-group.arn
  target_id        = aws_instance.web-server2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target-group-att3" {
  target_group_arn = aws_lb_target_group.hmw-target-group.arn
  target_id        = aws_instance.web-server3.id
  port             = 80
}

resource "aws_lb_listener" "hmw-alb-listener" {
  load_balancer_arn = aws_lb.hmw-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hmw-target-group.arn
  }
}
// CREATE LISTENER RULE
resource "aws_lb_listener_rule" "hmw-alb-listener-rule" {
  listener_arn       = aws_lb_listener.hmw-alb-listener.arn
  priority           = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hmw-target-group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

// CREATING A LOAD BALANCER
resource "aws_lb" "hmw-alb" {
        name               = "hmw-alb"
        internal           = false
        ip_address_type    = "ipv4"
        load_balancer_type = "application"
        security_groups    = [aws_security_group.hmw-sg.id]
        subnets            = [aws_subnet.hmw-public-subnets1.id, aws_subnet.hmw-public-subnets2.id, aws_subnet.hmw-public-subnets3.id]
        enable_deletion_protection = false
}
output "elb-dns-name" {
        value = aws_lb.hmw-alb.dns_name
}

// SETTING UP AWS LAUNCH TEMPLATE
resource "aws_launch_template" "hmw-launchtemp" {
  name          = "hmw-launchtemp"
  image_id      = "ami-06878d265978313ca"
  instance_type = "t2.micro"
}

//SETTING UP AUTO-SCALING GROUP

// resource "aws_autoscaling_group" "hmw-asg" {
//   name               = "hmw-asg"
//   availability_zones = ["us-east-1a"]
//   min_size           = 3
//   max_size           = 4
//   desired_capacity   = 3
//   target_group_arns  = [aws_lb_target_group.hmw-target-group.arn]
//   launch_template    = aws_launch_template.hmw-launchtemp.id
// }

// resource "aws_autoscaling_attachment" "hmw-asg_attachment" {
//   autoscaling_group_name = aws_autoscaling_group.hmw-asg.id
//   elb                    = aws_lb.hmw-alb.id
// }