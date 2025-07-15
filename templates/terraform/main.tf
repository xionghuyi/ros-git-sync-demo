data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

resource "alicloud_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "172.16.0.0/24"
  zone_id      = data.alicloud_zones.default.zones.0.id

}

resource "alicloud_security_group" "group" {
  security_group_name = "demo"
  vpc_id              = alicloud_vpc.vpc.id
}

resource "alicloud_instance" "instance" {
  count                      = var.number

  availability_zone          = data.alicloud_zones.default.zones.0.id
  security_groups            = alicloud_security_group.group.*.id

  instance_type              = var.instance_type
  system_disk_category       = "cloud_essd"
  system_disk_name           = "disk"
  image_id                   = "aliyun_3_x64_20G_alibase_20250629.vhd"
  instance_name              = "demo"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
}