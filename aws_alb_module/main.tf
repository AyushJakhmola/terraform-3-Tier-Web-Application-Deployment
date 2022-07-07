resource "aws_security_group" "alb_sg" {
  vpc_id = var.sample_vpc_id
  dynamic "ingress" {
    for_each = var.alb_inbound_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = var.inbound_protocol
      cidr_blocks = local.anywhere
    }
  }
  tags = {
    Name = "alb_sg"
  }
}
resource "aws_lb" "webapp-alb" {
  name               = "webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.aws_public_subnet_ids

  tags = {
    Name = "webapp-alb"
  }
}
resource "aws_lb_target_group" "webapp-alb-tg" {
  name     = "webapp-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.sample_vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.webapp-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-alb-tg.arn
  }
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.webapp-alb-tg.arn
  target_id        = var.instance_id
  port             = 80
}