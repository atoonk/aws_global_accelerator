package main
import (
  "net/http"
    "fmt"
    "os"
)

var id string

func sayHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "hostname: " + id + "\n")
}

func main() {
  id  = os.Args[1]
  http.HandleFunc("/", sayHello)
  if err := http.ListenAndServe(":80", nil); err != nil {
    panic(err)
  }
}
