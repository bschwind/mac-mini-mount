$fn=200;

// All dimensions are in millimeters

body_width = 197;
body_depth = 197;
body_height = 36;
corner_radius = 30;

// The overall thickness of the outer shell
thickness = 2;

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
    fan_width = 71;

    // How far the cutouts should be from the ports themselves
    port_padding = 1;

    // X coordinates of various ports, starting from the left
    power_button_left = 9;
    ethernet_port_right = 56;
    fan_left = 63;
    fan_right = 134;
    left_usb_port_left = 141;
    right_usb_port_right = 171;

    // The insets for the top and bottom of the port cutouts.
    top_inset = 3;
    bottom_inset = 7;

    translate([0, 50, 0])
    rotate([90, 0, 0])
    linear_extrude(100)
    union() {
        polygon(
            [
                [power_button_left - port_padding, bottom_inset],
                [power_button_left - port_padding, body_height - top_inset],
                [ethernet_port_right + port_padding, body_height - top_inset],
                [ethernet_port_right + port_padding, bottom_inset],
            ]
        );
        polygon(
            [
                [fan_left - port_padding, bottom_inset],
                [fan_left - port_padding, body_height - top_inset],
                [fan_right + port_padding, body_height - top_inset],
                [fan_right + port_padding, bottom_inset],
            ]
        );
        polygon(
            [
                [left_usb_port_left - port_padding, bottom_inset],
                [left_usb_port_left - port_padding, body_height - top_inset],
                [right_usb_port_right + port_padding+12, body_height - top_inset],
                [right_usb_port_right + port_padding+12, bottom_inset],
            ]
        );
    };
}

module top_cutout() {
    union() {
        translate([-100, 100, 0]) cube([400, 400, 400]);
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

rotate([90, 0, 0])
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
