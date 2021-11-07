#Create a null resource
resource "null_resource" "name" {
  depends_on = [
    module.ec2_public
  ]
  # Connection Block for provisioners to connect to ec2 instance
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("private-key/terraform-key.pem")
  }

  ##File Provisioner : Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/terraform-key.pem"
    destination = "/tmp/terraform-key.pem"

  }

  ## Remote exec Provisioner: Using remote-exec provisioner fix the priavte key permission
  provisioner "remote-exec" {
    inline = [
      
      "sudo chmod 400 /tmp/terraform-key.pem"
    ]
  }

  ## Local Exec Provisioner: local exec provisioner
  provisioner "local-exec" {
    command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
    
  }

  #Creation time provisoners-By default they are create time provisioner
  #destroy time provisioners - Will be created during "terraform destroy" command


}
