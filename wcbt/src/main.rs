use chrono::{Local, NaiveTime};
use std::process::Command;
use std::thread;
use std::time::Duration;

const WALLPAPER_FOLDER: &str = "/home/lucas/Pictures/wallpapers/Outset Island";

const TIME_RANGES: [(
    core::option::Option<chrono::NaiveTime>,
    core::option::Option<chrono::NaiveTime>,
    &str,
    i32,
); 5] = [
    (
        NaiveTime::from_hms_opt(7, 0, 0),
        NaiveTime::from_hms_opt(12, 0, 0),
        "morning.jpg",
        0,
    ),
    (
        NaiveTime::from_hms_opt(12, 0, 0),
        NaiveTime::from_hms_opt(17, 30, 0),
        "day.jpg",
        1,
    ),
    (
        NaiveTime::from_hms_opt(17, 30, 0),
        NaiveTime::from_hms_opt(21, 0, 0),
        "evening.jpg",
        2,
    ),
    (
        NaiveTime::from_hms_opt(21, 0, 0),
        NaiveTime::from_hms_opt(23, 59, 59),
        "night.jpg",
        3,
    ),
    (
        NaiveTime::from_hms_opt(0, 0, 0),
        NaiveTime::from_hms_opt(7, 0, 0),
        "night.jpg",
        3,
    ),
];

fn main() {
    let mut last_index = -1;
    let mut new_index = 4; // doesn't exist

    let mut new_wallpaper = String::with_capacity(57); // DIR_PATH + morning/evening = 57 chars

    loop {
        let current_time = Local::now().time();

        for (start, end, image_filename, i) in &TIME_RANGES {
            if let (Some(start_time), Some(end_time)) = (start, end) {
                if current_time >= *start_time && current_time < *end_time {
                    new_wallpaper.push_str(&[WALLPAPER_FOLDER, image_filename].join(" "));
                    new_index = *i;
                    break;
                }
            }
        }

        if last_index != new_index {
            println!("Changing Wallpaper to: {}", new_wallpaper);
            let _ = Command::new("feh")
                .args(&["--bg-fill", &new_wallpaper])
                .output();
            last_index = new_index;
        }

        new_wallpaper.clear();
        // Sleep for a minute before checking again
        thread::sleep(Duration::from_secs(60));
    }
}
