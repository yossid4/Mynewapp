resource "aws_lb" "leumi_nlb" {
  name               = "LoadBalancer"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = aws_subnet.leumi-a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.leumi-b.id
  }
}

resource "aws_lb_target_group" "leumitg" {
  name        = "leumitg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.leumi_vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    interval            = 30
    port                = 80
    protocol            = "TCP"
    timeout             = 10
    unhealthy_threshold = 2
  }
}



resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.leumi_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.leumitg.arn
  }
}



resource "aws_lb_target_group_attachment" "leumitg_attachment" {
  target_group_arn = aws_lb_target_group.leumitg.arn
  target_id        = aws_instance.Leumi-1.id
  port             = 80
  depends_on = [
    aws_instance.Leumi-1,
  ]
}