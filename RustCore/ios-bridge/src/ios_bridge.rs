use std::ffi::{CStr, CString};
use std::os::raw::c_char;
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

    match Repository::clone(&url, &path) {
        Ok(_) => 0,  // Success
        Err(_) => -1, // Failure
    }
}

#[no_mangle]
pub extern "C" fn free_c_string(ptr: *mut c_char) {
    if ptr.is_null() { return; }
    unsafe { let _ = CString::from_raw(ptr); } // ✅ Properly frees memory
}
