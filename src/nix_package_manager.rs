struct NixPackageManager {}

impl PackageManager for NixPackageManager {
    fn run_program(&self, program_name: &str) {}
}
