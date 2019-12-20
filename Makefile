.help:
	@echo "make darwin   building point on macOS"
	@echo "make windows  building point on windows"
	@echo "make linux    building point and vswitch on linux"
	@echo "make install  install openlan to linux"

linux:
	go build -o ./resource/point.linux.x86_64 main/point_linux.go
	go build -o ./resource/vswitch.linux.x86_64 main/vswitch_linux.go
	go build -o ./resource/pointctl.linux.x86_64 main/pointctl.go
	go build -o ./resource/openlan.linux.x86_64 main/openlan.go

windows:
	go build -o ./resource/point.windows.x86_64 main/point_windows.go
	# ResourceHacker -open main.exe -save output.exe -action addskip -res main.ico -mask ICONGROUP,MAIN,
	go build -o ./resource/vswitch.windows.x86_64 main/vswitch_linux.go
	go build -o ./resource/openlan.linux.x86_64 main/openlan.go

osx: darwin

darwin:
	go build -o ./resource/point.darwin.x86_64 main/point_darwin.go
	go build -o ./resource/pointctl.darwin.x86_64 main/pointctl.go
	go build -o ./resource/openlan.linux.x86_64 main/openlan.go

install:
	./install.sh

rpm:
	# prepare 
	./packaging/auto.sh

	# building
	rpmbuild -ba ./packaging/openlan-point.spec
	rpmbuild -ba ./packaging/openlan-vswitch.spec

	# copy 
	cp -rvf ~/rpmbuild/RPMS/x86_64/openlan-* ./resource

winzip:
	mkdir -p ./openlan-wins
	cp -rvf ./resource/point.windows.x86_64 ./openlan-wins/point.windows.x86_64.exe
	cp -rvf ./resource/point.json ./openlan-wins/point.json
	zip -r ./resource/openlan-wins.zip ./openlan-wins
