# vim: et sw=4 ts-4 sr smartindent:
resource "aws_vpc" "mod" {
    cidr_block           = "${var.cidr}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    enable_dns_support   = "${var.enable_dns_support}"
    tags                 = {
        name        = "${var.aws_tags_name}-vpc"
        environment = "${var.aws_tags_env}"
        service     = "${var.aws_tags_service}"
        build       = "${var.aws_tags_build_num}"
    }
}

resource "aws_internet_gateway" "mod" {
    vpc_id = "${aws_vpc.mod.id}"
    tags   = {
        name        = "${var.aws_tags_name}-ig"
        environment = "${var.aws_tags_env}"
        service     = "${var.aws_tags_service}"
        build       = "${var.aws_tags_build_num}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.mod.id}"
    tags   = {
        name        = "${var.aws_tags_name}-rt_pub"
        environment = "${var.aws_tags_env}"
        service     = "${var.aws_tags_service}"
        build       = "${var.aws_tags_build_num}"
    }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id         = "${aws_route_table.public.id}"
    gateway_id             = "${aws_internet_gateway.mod.id}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.mod.id}"
    tags   = {
        name        = "${var.aws_tags_name}-rt_prv"
        environment = "${var.aws_tags_env}"
        service     = "${var.aws_tags_service}"
        build       = "${var.aws_tags_build_num}"
    }
}

resource "aws_subnet" "private" {
    vpc_id            = "${aws_vpc.mod.id}"
    cidr_block        = "${element(split(",", var.private_subnets), count.index)}"
    availability_zone = "${element(split(",", var.azs), count.index)}"
    count             = "${length(compact(split(",", var.private_subnets)))}"
    tags   = {
        name        = "${var.aws_tags_name}-sub_prv"
        environment = "${var.aws_tags_env}"
        service     = "${var.aws_tags_service}"
        build       = "${var.aws_tags_build_num}"
    }
}

resource "aws_subnet" "public" {
    vpc_id            = "${aws_vpc.mod.id}"
    cidr_block        = "${element(split(",", var.public_subnets), count.index)}"
    availability_zone = "${element(split(",", var.azs), count.index)}"
    count             = "${length(compact(split(",", var.public_subnets)))}"
    tags   = {
        name        = "${var.aws_tags_name}-sub_pub"
        environment = "${var.aws_tags_env}"
        service     = "${var.aws_tags_service}"
        build       = "${var.aws_tags_build_num}"
    }

    map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
    count          = "${length(compact(split(",", var.private_subnets)))}"
    subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
    count          = "${length(compact(split(",", var.public_subnets)))}"
    subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
}
