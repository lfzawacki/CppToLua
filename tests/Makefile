TESTS = inline empty_inline operators return_classes simple cppstl everything pointers

tests: $(TESTS)

%: %.h
	@echo ""
	@echo "Testing" $*
	@echo "---------------"
	@./test $*

clean:
	rm log.txt
