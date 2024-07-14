use kalk::{kalk_value::ScientificNotationFormat, parser};

#[flutter_rust_bridge::frb]
pub struct KalkResult {
    pub is_error: bool,
    pub content: String,
}

#[flutter_rust_bridge::frb(sync)]
pub fn calc_str(input: String) -> KalkResult {
    let mut parser_context = parser::Context::new();
    let format = ScientificNotationFormat::Normal;
    match parser::eval(&mut parser_context, input.as_str(), (2048 as isize) as u32) {
        Ok(Some(result)) => KalkResult {
            is_error: false,
            content: result.to_string_pretty_format(format),
        },
        Ok(None) => KalkResult {
            is_error: false,
            content: "".to_string(),
        },
        Err(err) => KalkResult {
            is_error: true,
            content: err.to_string(),
        },
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
