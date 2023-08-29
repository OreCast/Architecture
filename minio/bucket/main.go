package main

// test module for minio APIs
// full documentation can be found here
// https://min.io/docs/minio/linux/developers/go/API.html#ListBucket

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"

	minio "github.com/minio/minio-go/v7"
	credentials "github.com/minio/minio-go/v7/pkg/credentials"
)

// Configuration represents basic configuration objec
type Configuration struct {
	Endpoint  string `json:"endpoint"`   // minio server URI, e.g. localhost:90009
	AccessKey string `json:"access_key"` // minio access key
	Secret    string `json:"secret"`     // minio access key secret
	UseSSL    bool   `json:"use_ssl"`    // use ssl in minio connection
	Verbose   int    `json:"verbose"`    // verbosity level
}

// Config is instance of Configruation object
var Config Configuration

// helper function to parse configuration
func parseConfig(configFile string) error {
	data, err := ioutil.ReadFile(configFile)
	if err != nil {
		log.Println("Unable to read", err)
		return err
	}
	err = json.Unmarshal(data, &Config)
	if err != nil {
		log.Println("Unable to parse", err)
		return err
	}
	return err
}

// helper function to test minio funtionality
func minioHelper() {
	// Initialize minio client object
	minioClient, err := minio.New(Config.Endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(Config.AccessKey, Config.Secret, ""),
		Secure: Config.UseSSL,
	})
	if err != nil {
		log.Fatalln(err)
	}
	log.Printf("%#v\n", minioClient)
	// minioClient is now setup
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	buckets, err := minioClient.ListBuckets(ctx)
	if err != nil {
		fmt.Println(err)
		return
	}
	for _, bucket := range buckets {
		fmt.Println(bucket)
	}
	// get bucket tags
	bucket := "bucket"
	log.Println("\n### now list single bucket content", bucket)
	tags, err := minioClient.GetBucketTagging(ctx, bucket)
	if err != nil {
		log.Fatalln(err)
	}
	fmt.Printf("\nbucket %v Object Tags: %v\n", bucket, tags)
	prefix := "mac" // pattern we would like to apply, put empty string to list everything
	objectCh := minioClient.ListObjects(ctx, bucket, minio.ListObjectsOptions{
		Prefix:    prefix,
		Recursive: true,
	})
	for object := range objectCh {
		if object.Err != nil {
			fmt.Println(object.Err)
			return
		}
		fmt.Printf("%v %s %10d %s\n", object.LastModified, object.ETag, object.Size, object.Key)
	}
}

func main() {
	var config string
	flag.StringVar(&config, "config", "config.json", "dbs2go config file")
	var version bool
	flag.BoolVar(&version, "version", false, "Show version")
	flag.Parse()
	err := parseConfig(config)
	if err != nil {
		log.Fatalf("Unable to parse config file %s, error: %v", config, err)
	}
	if Config.Verbose > 0 {
		// be verbose in log output, i.e. show code lines
		log.SetFlags(log.LstdFlags | log.Lshortfile)
	}
	log.Println("Config", Config)
	minioHelper()
}
