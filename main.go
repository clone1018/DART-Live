package main

import (
	"encoding/json"
	"fmt"
	"github.com/bdon/go.gtfs"
	"net/http"
	"os"

	"database/sql"

	_ "github.com/lib/pq"
)

func main() {
	gtfs, err := sql.Open("gtfs", "user=ubuntu dbname=dartlive sslmode=verify-full")
	if err != nil {
		log.Fatal(err)
	}

	rows, err := db.Query("SELECT * FROM gtfs.routes;")
	if err != nil {
		panic(err)
	}
	
	os.Exit(0)

	fs := http.FileServer(http.Dir("public"))
	http.Handle("/", fs)

	http.ListenAndServe(":8080", nil)
}
