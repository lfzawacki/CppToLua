TESTS = inline operators return_classes simple

LOG = log.txt

tests: $(TESTS)
	@echo "Starting tests" > $(LOG)

%: %.h
	@echo ""
	@echo "Testing" $*
	@echo "---------------"
	@./test $* $(LOG)

clean:
	rm log.txt
