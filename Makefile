dist/libtil_queue.so: til source/app.d
	ldc2 --shared source/*.d \
		-I=til/source -I=source \
		-link-defaultlib-shared \
		-L-L${PWD}/dist -L-L${PWD}/til/dist -L-ltil \
		--O2 -of=dist/libtil_queue.so

test:
	til/til.release test.til

til:
	git clone https://github.com/til-lang/til.git til

clean:
	-rm dist/*.so
