// This is the sample race data. Replace with your input.
const RACES: &'static [(i32, i32)] = &[(7, 9), (15, 40), (30, 200)];

fn main() {
    let mut margin = 0;
    for race in RACES.iter() {
        let mut winning_combos = 0;
        let time = race.0;
        let record = race.1;

        for velocity in 0..time {
            let distance = velocity * (time - velocity);
            if distance > record {
                winning_combos += 1;
            }
        }

        if margin == 0 {
            margin = winning_combos;
        }
        else {
            margin *= winning_combos;
        }
    }

    println!("{}", margin);
}
