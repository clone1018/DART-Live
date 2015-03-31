package main

import (
	"net/http"
	"github.com/bdon/go.gtfs"
	"fmt"
	"os"
	"encoding/json"
)

func main() {
	fmt.Println("Loading ~/google-transit")
	feed := gtfs.Load("/home/clone1018/google-transit", true)
	fmt.Println("Done Loading ~/google-transit")
	route := feed.RouteByShortName("533")
	fmt.Println("Finding route")

	strB, err := json.Marshal(route.LongestShape())
	if err != nil {
		panic(err)
	}
	fmt.Println(string(strB))

	for _, shape := range route.Shapes() {
		for _, coords := range shape.Coords {
			fmt.Println(coords)
		}
	}

	fmt.Printf("%v", route.Shapes())
	os.Exit(0)

	fs := http.FileServer(http.Dir("public"))
	http.Handle("/", fs)

	http.ListenAndServe(":8080", nil)
}
