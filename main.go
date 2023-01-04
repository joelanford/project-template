package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/joelanford/project-template/internal/version"
	_ "k8s.io/client-go"
)

func main() {
	// TODO: replace with your own main function
	fmt.Printf("Git Version : %s\n", version.GitVersion)
	fmt.Printf("Git Commit  : %s\n", version.GitCommit)
	fmt.Println("Listening on :8080...")
	s := &http.Server{
		Addr:              ":8080",
		ReadHeaderTimeout: 3 * time.Second,
		Handler: http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			fmt.Fprintln(w, "Hello, World!")
		})}
	_ = s.ListenAndServe()
}
