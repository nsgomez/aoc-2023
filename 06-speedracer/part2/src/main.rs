fn main() {
    // This is the sample race data. Replace with your input.
    let time: u64 = 71530;
    let record: u64 = 940200;

    // This isn't precise but we need to start somewhere
    let mut min_time: u64 = record / time;
    let mut max_time: u64 = time - min_time;

    for velocity in min_time..time {
        let distance = velocity * (time - velocity);
        if distance > record {
            break;
        }
        else {
            min_time = min_time + 1;
        }
    }

    for velocity in (0..max_time).rev() {
        let distance = velocity * (time - velocity);
        if distance > record {
            break;
        }
        else {
            max_time = max_time - 1;
        }
    }

    println!("Range of winning races: [{}, {})", min_time, max_time);
    println!("Number of winning racecs: {}", max_time - min_time);
}
