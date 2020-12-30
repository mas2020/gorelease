# Makefile to manage Go-AL
export GOAL_HOME=$(PWD)/.goal

test:
	@echo "==> goal test..."
	@go test ./... -v

gotest:
	@echo "==> goal gotest..."
	@gotest ./...

build:
	@echo "start building..."
	#@go build -o bin/goal main.go
	@goreleaser  --rm-dist --snapshot --skip-publish
	@echo "done!"

install: build test
	@echo "start install..."
	@echo "copying into $(GOPATH)/bin..."
	@cp dist/goal_darwin_amd64/goal $(GOPATH)/bin
	@echo "done!"

run:
	clear
	go run main.go

compile:
	# compile Go-AL for several platform
	@echo "oompiling for every OS and Platform..."
	GOOS=darwin GOARCH=amd64 go build -o bin/goal-darwin-amd64 main.go
	GOOS=linux GOARCH=amd64 go build -o bin/goal-linux-amd64 main.go
	GOOS=windows GOARCH=amd64 go build -o bin/goal-windows-amd64.exe main.go
	@echo "done!"

clean:
	@rm -rf bin/*
	@rm -rf dist/*

look_update_pkgs:
	# take a look at the newer versions of dependency modules
	@go list -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}}: {{.Version}} -> {{.Update.Version}}{{end}}' -m all 2> /dev/null