# output "external_ip_address_reddit" {
#   value = yandex_compute_instance.reddit[*].network_interface.0.nat_ip_address
# }

output "external_ip_address_reddit" {
  value = [
    for inst in yandex_compute_instance.reddit :
    "IP of ${inst.name} is ${inst.network_interface.0.nat_ip_address}"
  ]
}

# output "external_ip_address_lb" {
#   value = yandex_lb_network_load_balancer.lb.listener[*].external_address_spec[*].address
# }

# output "external_ip_address_lb" {
#   value = tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address
# }
