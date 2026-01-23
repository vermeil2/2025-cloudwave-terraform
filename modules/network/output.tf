output "vpc_id" {
  value = aws_vpc.main.id
}

########################################################
# Private Subnets
########################################################
output "private_subnet_id_zone1" {
  description = "ID of the private subnet in Zone 1"
  value       = aws_subnet.private_zone1.id
}

output "private_subnet_id_zone2" {
  description = "ID of the private subnet in Zone 2"
  value       = aws_subnet.private_zone2.id
}

########################################################
# Public Subnets
########################################################
output "public_subnet_id_zone1" {
  description = "ID of the public subnet in Zone 1"
  value       = aws_subnet.public_zone1.id
}

output "public_subnet_id_zone2" {
  description = "ID of the public subnet in Zone 2"
  value       = aws_subnet.public_zone2.id
}
########################################################
# NAT Gateway
########################################################
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "elastic_ip_allocation_id" {
  description = "Elastic IP Allocation ID for the NAT Gateway"
  value       = aws_eip.nat.id
}

########################################################
# Route Tables
########################################################
output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

########################################################
# Associations
########################################################
output "private_route_table_associations" {
  description = "Route table associations for private subnets"
  value       = [
    aws_route_table_association.private_zone1.id,
    aws_route_table_association.private_zone2.id
  ]
}

output "public_route_table_associations" {
  description = "Route table associations for public subnets"
  value       = [
    aws_route_table_association.public_zone1.id,
    aws_route_table_association.public_zone2.id
  ]
}