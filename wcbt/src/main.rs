use chrono::{Local, NaiveTime};
use std::process::Command;
use std::thread;
use std::time::Duration;

fn main() {
    let mut index = -1;
    loop {
        let now = Local::now();
        let mut new_index = 4; // doesn't exist
        let mut new_wallpaper = String::new();

        let time_ranges = [
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

        let current_time = now.time();
        for (start, end, image_filename, i) in &time_ranges {
            if let (Some(start_time), Some(end_time)) = (start, end) {
                if current_time >= *start_time && current_time < *end_time {
                    new_wallpaper = format!(
                        "/home/lucas/Pictures/wallpapers/Outset Island {}",
                        image_filename
                    );
                    new_index = *i;
                    break;
                }
            }
        }

        if new_index != index {
            println!("Changing Wallpaper to: {}", new_wallpaper);
            let _ = Command::new("feh")
                .args(&["--bg-fill", &new_wallpaper])
                .output();
            index = new_index;
        }

        // Sleep for a minute before checking again
        thread::sleep(Duration::from_secs(10));
    }
}
