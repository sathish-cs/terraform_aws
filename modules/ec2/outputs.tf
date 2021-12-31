# Public SG
output "public_sg_id" {
    value = "module.public-sg.this_security_group_id"
}

# Private SG 
output "private_sg_id" {
    value = "module.private-sg.this_security_group_id"
}

