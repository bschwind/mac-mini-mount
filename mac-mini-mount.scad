$fn=200;

// All dimensions are in millimeters

body_width = 197;
body_depth = 197;
body_height = 36;
corner_radius = 30;

// The overall thickness of the outer shell
thickness = 2;
top_bottom = 3;

module rounded_box(w,d,h,r) {
    translate([r,r,0])
    minkowski() {
        cube([w-(r*2), d-(r*2), h/2]);
        cylinder(r=r, h=h/2);
    }
}

module mac_mini_body() {
    rounded_box(body_width, body_depth, body_height, corner_radius);
}

module outer_shell() {
    minkowski() {
        mac_mini_body();
        cube([thickness*2, thickness*2, thickness*2], center = true);
    }
}

module port_cutouts() {
    fan_width = 72;

    // How far the cutouts should be from the ports themselves
    port_padding = 1;

    // X coordinates of various ports, starting from the left
    power_button_left = 10;
    ethernet_port_right = 53;
    fan_left = 60;
    fan_right = 131;
    left_usb_port_left = 137;
    right_usb_port_right = 170;

    translate([0, 50, 0])
    rotate([90, 0, 0])
    linear_extrude(100)
    union() {
        polygon(
            [
                [power_button_left - port_padding, top_bottom],
                [power_button_left - port_padding, body_height - top_bottom],
                [ethernet_port_right + port_padding, body_height - top_bottom],
                [ethernet_port_right + port_padding, top_bottom],
            ]
        );
        polygon(
            [
                [fan_left - port_padding, top_bottom],
                [fan_left - port_padding, body_height - top_bottom],
                [fan_right + port_padding, body_height - top_bottom],
                [fan_right + port_padding, top_bottom],
            ]
        );
        polygon(
            [
                [left_usb_port_left - port_padding, top_bottom],
                [left_usb_port_left - port_padding, body_height - top_bottom],
                [right_usb_port_right + port_padding+12, body_height - top_bottom],
                [right_usb_port_right + port_padding+12, top_bottom],
            ]
        );
    };
}

module top_cutout() {
    union() {
        translate([-100, 70, 0]) cube([400, 400, 400]);
        translate([-100, body_depth/2, -20]) cube([400, 400, 400]);
    }
}

module curved_front_cutout() {
    translate([100, 100, 0]) cylinder(h=300, r=90);
}

module mounting_hole(x, y) {
    hole_diameter = 4.5;
    translate([x, y, -20]) cylinder(r = hole_diameter / 2, h = 30);
}

difference() {
    outer_shell();
    mac_mini_body();
    port_cutouts();
    top_cutout();
    curved_front_cutout();
    mounting_hole(6, 90);
    mounting_hole(body_width - 6, 90);
    mounting_hole((body_width / 2) - 7, 6);
    mounting_hole((body_width / 2) + 7, 6);
}
