resource "aws_security_group" "alb_sg" {
  vpc_id = var.sample_vpc_id
  dynamic "ingress" {
    for_each = var.alb_inbound_ports
      content {
      from_port   = ingress.value.internal
      to_port     = ingress.value.external
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.CidrBlock]
    }
  }  
  tags = {
    Name = "allow_tls"
  }
}
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.aws_public_subnet_ids

  tags = {
    Name = "alb"
  }
}
resource "aws_lb_target_group" "alb-tg" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.sample_vpc_id
}

resource "aws_lb_listener" "alb-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = var.instance_id
  port             = 80
}

#launch configuration
resource "aws_launch_configuration" "LaunchConfig" {
  name              = "Launch-config"
  image_id          = var.instance_ami
  instance_type     = var.asgInstanceType
  key_name          = var.instance_key_name
  security_groups   = [var.instance_sg]
  enable_monitoring = true
}
#autoscaling group
resource "aws_autoscaling_group" "AutoScalinGroup" {
  name                      = "AutoScalinGroup"
  launch_configuration      = aws_launch_configuration.LaunchConfig.name
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.alb-tg.arn]
}