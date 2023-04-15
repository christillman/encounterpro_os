BEGIN { FS = ","; ck = 0 }
{
if ($0 ~ /^[0-9][0-9]*,NDA/) {
	printf "%s", "\n"
	}
if ($0 !~ /"/ && NF == 12) {
	ck = 1;
	printf "%s", $0
	}
else {
		ck = 2;
		gsub("\"", "");
		gsub("\n", "");
		printf "%s", $0
	}
}


