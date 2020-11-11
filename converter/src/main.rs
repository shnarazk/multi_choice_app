use {
    serde_derive::{Deserialize, Serialize},
    serde_json,
    serde_yaml,
    std::io::{self, Read},
};

#[derive(Debug, Serialize, Deserialize)]
struct Question {
    id: Option<isize>,
    text: String,
    code: Option<String>,
    choice: Vec<String>,
}

const OK_STR: &str = "⭕️";
const NG_STR: &str = "❌";

fn main() {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer).expect("something wrong");
    if let Ok(mut v) = serde_yaml::from_str::<Vec<Question>>(&buffer) {
        for (i, q) in v.iter_mut().enumerate() {
            q.id = Some(i as isize);
            q.choice[0].insert_str(0, OK_STR);
            for s in q.choice.iter_mut().skip(1) {
                s.insert_str(0, NG_STR);
            }
        }
        if let Ok(j) = serde_json::to_string(&v) {
            println!("{}", j);
        }
    } else {
        panic!("fail to parse");
    }
}
