# Application Load Balancer
resource "aws_lb" "my_alb" {
  name                             = var.lb_name
  internal                         = var.lb_internal
  load_balancer_type               = var.lb_load_balancer_type
  subnets                          = [var.public_snet_1, var.public_snet_2]
  enable_deletion_protection       = var.lb_enable_deletion_protection
  enable_http2                     = true
  enable_cross_zone_load_balancing = true
  security_groups                  = var.alb_security_group_id
  tags = {
    Name = "LB"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = var.lb_target_port
  protocol = var.lb_protocol
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}




