a = ["hello.txt", "-w", "hello"]
file_name = a.find{|x| x.end_with?(".txtf")}
print file_name