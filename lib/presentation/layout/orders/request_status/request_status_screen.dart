import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/edit_request.dart';

import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../models/attachment.dart';

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DefaultHeader(
              header: "",
              textAlignment: AlignmentDirectional.center,
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<OrderCubit, OrderState>(
              listener: (context, state) {
                if (state is SaveEditedDataErrorState) {
                  defaultErrorSnackBar(context: context, message: state.errMsg);
                } else if (state is GetRequestStatusErrorState) {
                  defaultErrorSnackBar(context: context, message: state.errMsg);
                } else if (state is SaveEditedDataSuccessState) {
                  defaultSuccessSnackBar(
                    context: context,
                    message: "Your Data has been saved Successfully",
                  );
                }
              },
              builder: (context, state) {
                var blocWatch = context.watch<OrderCubit>();
                var blocRead = context.read<OrderCubit>();
                if (state is GetRequestStatusLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (blocWatch.requestStatus != null) {
                  print(
                      "statuds index ${blocWatch.requestStatus!.requestStatus}");
                  if (blocWatch.requestStatus!.requestStatus == 0) {
                    print("yessss");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/pending_request.jpg"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "We are reviewing your documents and will notify you once the review is complete.",
                            style: AppFonts.inter16Black400.copyWith(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else if (blocWatch.requestStatus!.requestStatus == 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      ],
                    );
                  } else if (blocWatch.requestStatus!.requestStatus == 2) {
                    Attachment? nationalIdResult = findAttachmentFile(
                      type: "nationalId",
                      attachments: blocWatch.requestStatus!.attachmentsId,
                    );
                    Attachment? passportResult = findAttachmentFile(
                      type: "passport",
                      attachments: blocWatch.requestStatus!.attachmentsId,
                    );
                    return EditRequest(
                      blocWatch: blocWatch,
                      blocRead: blocRead,
                      nationalIdResult: nationalIdResult,
                      passportResult: passportResult,
                      requestId: requestId,
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
