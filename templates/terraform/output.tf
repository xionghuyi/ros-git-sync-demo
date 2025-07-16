output "public_ips" {
    value = alicloud_instance.instance[*].public_ip
}