# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_instance_role" {
  name = "EC2InstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Policy to Allow GetSecretValue
resource "aws_iam_policy" "secretsmanager_policy" {
  name        = "SecretsManagerPolicy"
  description = "Policy to allow GetSecretValue from Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"],
        Effect   = "Allow",
        Resource = var.secrets_manager_secret_arn,
      },
    ],
  })
}

# Attach the Inline Policy to the IAM Role
resource "aws_iam_policy_attachment" "secretsmanager_attachment" {
  name       = "SecretsManagerAttachment"
  policy_arn = aws_iam_policy.secretsmanager_policy.arn
  roles      = [aws_iam_role.ec2_instance_role.name]
}

# IAM Role Policy Attachment
resource "aws_iam_instance_profile" "instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_instance_role.name
}



# Launch Template
resource "aws_launch_template" "launch_templ" {
  name_prefix   = "launch_templ"
  image_id      = var.image_id
  instance_type = var.instance_type

  # Attach the IAM instance profile to the Launch Template
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.public_snet_1
    security_groups             = var.launch_template_security_group_id #[aws_security_group.SGtemplate.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "instance" # Name for the EC2 instances
    }
  }
}

# Auto Scaling Group with Launch Template
resource "aws_autoscaling_group" "ASG" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  launch_template {
    id      = aws_launch_template.launch_templ.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [var.public_snet_1, var.public_snet_2]
  name                      = "ASG"
  health_check_grace_period = 300
  min_elb_capacity          = 0
  health_check_type         = var.health_check_type
  termination_policies      = ["Default"]
  target_group_arns         = [var.target_group_arn] #[aws_lb_target_group.my_target_group.arn]
  #key_name            = "my_key_name"
}

