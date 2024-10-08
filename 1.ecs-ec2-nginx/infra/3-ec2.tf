data "aws_ami" "this" {
  most_recent = "true"
  owners      = ["self", "amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-template"
  image_id      = data.aws_ami.this.image_id
  instance_type = "t3.micro"

  # Specify the name of the key to be able to SSH into these instances from our local machines.
  # key_name               = "ec2ecsglog"

  vpc_security_group_ids = [aws_security_group.security_group.id]

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}
