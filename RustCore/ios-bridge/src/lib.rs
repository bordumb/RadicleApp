use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use radicle_cli::commands::rad_auth;  // Changed from auth to rad_auth
use radicle::node::Alias;
use std::str::FromStr;
use git2::{Repository, Error};

#[no_mangle]
pub extern "C" fn get_git_version() -> *const c_char {
    let version = "git version 2.34.0 (libgit2)".to_string();
    CString::new(version).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn clone_repo(url: *const c_char, path: *const c_char) -> i32 {
    let url = unsafe { CStr::from_ptr(url).to_string_lossy().into_owned() };
    let path = unsafe { CStr::from_ptr(path).to_string_lossy().into_owned() };

    println!("🚀 Attempting to clone: {} -> {}", url, path);

    match Repository::clone(&url, &path) {
        Ok(_) => {
            println!("✅ Clone successful: {} -> {}", url, path);
            0
        },
        Err(e) => {
            println!("❌ Clone failed: {:?} -> {:?}", e, path);
            -1
        }
    }
}


#[no_mangle]
pub extern "C" fn free_c_string(ptr: *mut c_char) {
    if ptr.is_null() { return; }
    unsafe { let _ = CString::from_raw(ptr); } // ✅ Properly frees memory
}

/// Convert Rust string to a C string for Swift interop
fn to_c_string(s: String) -> *mut c_char {
    CString::new(s).unwrap().into_raw()
}

/// Initialize Radicle authentication (rad auth --alias <name>)
#[no_mangle]
pub extern "C" fn rad_auth(alias: *const c_char) -> *mut c_char {
    let alias_str = unsafe { CStr::from_ptr(alias).to_string_lossy().into_owned() };
    
    // Convert alias to Radicle's expected format
    let alias = match Alias::from_str(&alias_str) {
        Ok(alias) => alias,
        Err(_) => return to_c_string("Invalid alias format".to_string()),
    };

    let options = rad_auth::Options { alias: Some(alias), stdin: false };
    
    match rad_auth::init(options) {
        Ok(_) => to_c_string("Rad auth successful".to_string()),
        Err(e) => to_c_string(format!("Rad auth failed: {}", e)),
    }
}

#[no_mangle]
pub extern "C" fn hw_hello_world() {
    println!("Hello from Rust!");
}
