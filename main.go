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
    fmt.Println("Request to home")
    w.Write([]byte("Hello from kapp"))
}

func VersionHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Println("Request to version")
    w.Write([]byte(fmt.Sprintf("Version: %v | Build: %v | GitHash: %v", Version, Build, GitHash)))
}

func main() {
    listenAddress := ":8877"
    r := mux.NewRouter()
    r.HandleFunc("/", HomeHandler)
    r.HandleFunc("/version", VersionHandler)
    http.Handle("/", r)
    http.ListenAndServe(listenAddress, nil)
    fmt.Printf("Listening on %v\n", listenAddress)
}
