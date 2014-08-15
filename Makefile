docker:
	docker build -t miser .

bash:
	docker run -t -i --privileged miser bash
