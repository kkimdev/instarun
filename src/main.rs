use std::{error::Error, vec};

extern crate nix_index;

use std::ffi::OsStr;
use std::fs::{self, File};
use std::io::{self, Write};
use std::path::PathBuf;
use std::process;

use clap::Parser;
use error_chain::ChainedError;
use futures::{future, StreamExt};
use nix_index::database::Writer;
use nix_index::errors::*;
use nix_index::files::FileTree;
use nix_index::hydra::Fetcher;
use nix_index::listings::{fetch_listings, try_load_paths_cache};
use nix_index::package::StorePath;
// use nix_index::CACHE_URL;
use separator::Separatable;

static CACHE_URL: &str = "https://cache.nixos.org/";

#[tokio::main]
async fn main() -> Result<()> {
    // https://github.com/nix-community/nix-index/blob/master/src/bin/nix-index.rs#L36
    let fetcher = Fetcher::new(CACHE_URL.to_string()).map_err(ErrorKind::ParseProxy)?;
    println!("checkpoint 1");
    let (files, watch) =
        nix_index::listings::fetch_listings(&fetcher, 20, "<nixpkgs>", vec![None], true)?;

    println!("checkpoint 2");
    // Treat request errors as if the file list were missing
    let files = files.map(|r| {
        r.unwrap_or_else(|e| {
            eprint!("\n{}", e.display_chain());
            None
        })
    });

    println!("checkpoint 3");
    // Add progress output
    let (mut indexed, mut missing) = (0, 0);
    let files = files.inspect(|entry| {
        if entry.is_some() {
            indexed += 1;
        } else {
            missing += 1;
        };

        eprint!("+ generating index: {:05} paths found :: {:05} paths not in binary cache :: {:05} paths in queue \r",
                indexed, missing, watch.queue_len());
        io::stderr().flush().expect("flushing stderr failed");
    });

    // Filter packages with no file listings available
    let mut files = files.filter_map(future::ready);

    eprint!("+ generating index");
    eprint!("\r");

    let mut results: Vec<(StorePath, String, FileTree)> = Vec::new();
    while let Some(entry) = files.next().await {
        println!("is any");
        let (path, _, files) = entry;
        println!("{:?}", path);
        dbg!(files);
        // db.add(path, files, args.filter_prefix.as_bytes())
        //     .chain_err(|| ErrorKind::WriteDatabase(args.database.clone()))?;
    }
    eprintln!();

    println!("done");
    return Ok(());
}
