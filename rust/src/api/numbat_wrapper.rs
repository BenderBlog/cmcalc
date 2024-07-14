#[flutter_rust_bridge::frb(sync)]
pub fn bmi_calc(weight: f64, height: f64) -> f64 {
    return weight / height.powi(2);
}
