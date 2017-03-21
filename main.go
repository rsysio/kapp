package main

import (
    "fmt"
    "net/http"
    "github.com/gorilla/mux"
)

var (
	Version string
	Build   string
	GitHash string
)

//export PrintVersion
func PrintVersion() {
	fmt.Println("---------------------------------------------------")
	fmt.Printf("Version: %s\n", Version)
	fmt.Printf("Build: %s\n", Build)
	fmt.Printf("GitHash: %s\n", GitHash)
	fmt.Println("---------------------------------------------------")
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello from kapp"))
}

func VersionHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte(Version))
}

func main() {
    r := mux.NewRouter()
    r.HandleFunc("/", HomeHandler)
    r.HandleFunc("/version", VersionHandler)
    http.Handle("/", r)
    http.ListenAndServe(":8877", nil)
}
