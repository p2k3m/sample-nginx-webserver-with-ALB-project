##############################################################################
# PUBLIC Zone Load Balancing
##############################################################################
resource "aws_alb" "public-load-balancer" {
  name            = "public-load-balancer"
  security_groups = ["${aws_security_group.public-alb-sg.id}"]

  subnets = [
    "${aws_default_subnet.public_subnet_1_cidr.id}",
    "${aws_default_subnet.public_subnet_2_cidr.id}",
    "${aws_default_subnet.public_subnet_3_cidr.id}",
  ]
}

resource "aws_alb_target_group" "public-ec2-target-group" {
  name     = "public-ec2-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_default_vpc.default.id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  depends_on = [
    "aws_alb.public-load-balancer",
  ]

  tags {
    Name = "public-ec2-target-group"
  }
}

resource "aws_alb_listener" "public-alb-listener" {
  load_balancer_arn = "${aws_alb.public-load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"


  default_action {
    target_group_arn = "${aws_alb_target_group.public-ec2-target-group.arn}"
    type             = "forward"
  }



}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_alb_target_group.public-ec2-target-group.arn}"
  target_id        = "${aws_instance.web.id}"
  port             = 80
}
