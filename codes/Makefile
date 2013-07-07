SHSRC=hello.sh

IEXSRC = arithmetic_operations.exs \
	bad_match.exs \
	basic_data_type.exs \
	binary_and_list.exs \
	binary_list_calc1.exs \
	binary_list_calc2.exs \
	binary_operations.exs \
	bool_operations.exs \
	case_syntax.exs \
	cond_syntax.exs \
	equivalent.exs \
	embedd_to_literal.exs \
	fn_syntax.exs \
	function_object.exs \
	function_syntax.exs \
	hat_operator1.exs \
	if_syntax.exs \
	in_operator.exs \
	keyword_list.exs \
	list_operations.exs \
	list_resuce_partial_app.exs \
	order_of_types.exs \
	pipeline_flatten_and_double.exs \
	pipeline_flatten_and_double2.exs \
	rebinding.exs \
	receive_syntax.exs \
	tuple_data_type.exs

TARGET=$(IEXSRC:.exs=.lst) $(SHSRC:.sh=.lst)

%.lst:%.sh
	sh sh_session.sh $<

%.lst:%.exs
	sh iex_session.sh $<

all: $(TARGET)

clean-tmp:
	-rm $(IEXSRC:.exs=.cmd) $(TARGET:.lst=.tmp)

clean: 
	-rm $(TARGET) $(IEXSRC:.exs=.cmd)
