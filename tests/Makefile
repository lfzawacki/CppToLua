TESTS = inline operators return_classes simple

tests: $(TESTS)

%: %.h
	@echo ""
	@echo "Testing" $*
	@echo "---------------"
	@./test $*

clean:
	rm log.txt
