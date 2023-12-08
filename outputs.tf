output "public_snet_1" {
  value = module.network.public_subnets.public_snet_1

}
output "public_snet_2" {
  value = module.network.public_subnets.public_snet_2
}
output "public_subnets" {
  value = module.network.public_subnets
}
output "private_subnets" {
  value = module.network.private_subnets
}
output "private_snet_1" {
  value = module.network.private_subnets.private_snet_1
}
output "private_snet_2" {
  value = module.network.private_subnets.private_snet_2
}
output "vpc_id" {
  value = module.network.vpc_id
}
