part of 'order_cubit.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;

  const factory OrderState.getAllRequestsLoading() = GetAllRequestsLoadingState;
  const factory OrderState.getAllRequestsSuccess() = GetAllRequestsSuccessState;
  const factory OrderState.getAllRequestsError(final String errMsg) =
      GetAllRequestsErrorState;

  const factory OrderState.getRequestStatusLoading(final String requestId) =
      GetRequestStatusLoadingState;
  const factory OrderState.getRequestStatusSuccess(final String requestId) =
      GetRequestStatusSuccessState;
  const factory OrderState.getRequestStatusError(final String errMsg) =
      GetRequestStatusErrorState;

  const factory OrderState.saveEditedDataLoading() = SaveEditedDataLoadingState;
  const factory OrderState.saveEditedDataSuccess(
      final RequestStatusModel status) = SaveEditedDataSuccessState;
  const factory OrderState.saveEditedDataError(final String errMsg) =
      SaveEditedDataErrorState;

  const factory OrderState.saveEditedFileLoading(final String fileId) =
      SaveEditedFileLoadingState;
  const factory OrderState.saveEditedFileSuccess(final String fileId) =
      SaveEditedFileSuccessState;
  const factory OrderState.saveEditedFileError(
      final String errMsg, final String fileId) = SaveEditedFileErrorState;

  const factory OrderState.submitEditsLoading() = SubmitEditsLoadingState;
  const factory OrderState.submitEditsSuccess() = SubmitEditsSuccessState;
  const factory OrderState.submitEditsError(final String errMsg) =
      SubmitEditsErrorState;

  const factory OrderState.submitEditStatusLoading() =
      SubmitEditStatusLoadingState;
  const factory OrderState.submitEditStatusSuccess(
          final String requestId, final int requestStatus) =
      SubmitEditStatusSuccessState;
  const factory OrderState.submitEditStatusError(final String errMsg) =
      SubmitEditStatusErrorState;

  const factory OrderState.selectNationalIdFile(final int fileStatus) =
      SelectNationalIdFileState;
  const factory OrderState.selectPassportFile(final int fileStatus) =
      SelectPassportFileState;

  const factory OrderState.changeIsWithPrivateEditValue({
    required final bool isWithPrivateDriver,
  }) = ChangeIsWithPrivateEditValueState;

  const factory OrderState.calculateEditedPrice({
    required final num price,
  }) = CalculateEdittedPriceState;

  const factory OrderState.changeEditedDatesValue({
    required DateTime? pickUp,
    required DateTime? delivery,
  }) = ChangeEditedDatesValueState;
}
