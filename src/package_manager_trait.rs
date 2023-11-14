trait PackageManager {
    fn run_program(&self, program_name: &str);
    fn is_program_installed();
    fn is_program_cached();
}
