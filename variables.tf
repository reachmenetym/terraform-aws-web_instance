variable "web_instance_count" {
    type = number 
}

variable "provision_web" {
    
}

variable "web_instance_type" {

}

variable "ami_id" {

}

variable "web_volume" {
    default = {
        volume_size = 10
        volume_type = "gp2"
        device_name = "/dev/sda1"
    }
    type = map
}

variable "ssh_key_name" {

}

variable "userdata" {
    
}

variable "vpc_id" {
  
}