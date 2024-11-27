import 'package:bloc/bloc.dart';
import 'package:flutterui/components/presentation/export/store.dart';
import 'package:flutterui/app/presentation/home/model/component_block_model.dart';
import 'package:flutterui/app/shared/data/models/component.dart';
import 'package:flutterui/debug_tool/log_helper.dart';

part 'component_event.dart';
part 'component_state.dart';

class ComponentBloc extends Bloc<ComponentEvent, ComponentState> {
  static const tag = "ComponentBloc";

  ComponentBloc() : super(ComponentInitial(activeComponent: AllComponents.widgets.first, allComponents: [])) {
    on<UpdateActiveCategoryEvent>((event, emit) {
      LogHelper.d(tag, "UpdateActiveCategoryEvent");
      emit(UpdateActiveCategorySuccess(
        activeComponent: state.activeComponent,
        allComponents: AllComponents.widgets,
        activeCategory: event.category,
      ));
    });
    on<GetAllComponentsEvent>((event, emit) {
      LogHelper.d(tag, "GetAllComponentsEvent");
      emit(FetchComponents(
        activeComponent: state.activeComponent,
        allComponents: AllComponents.widgets,
        activeCategory: state.activeCategory,
      ));
    });
    on<UpdateActiveComponentEvent>((event, emit) {
      LogHelper.d(tag, "UpdateActiveComponentEvent");
      emit(UpdateActiveComponentSuccess(
        activeComponent: event.newComponent,
        allComponents: state.allComponents,
        activeCategory: state.activeCategory,
      ));
    });
    on<FindNextComponentBlocEvent>((event, emit) {
      LogHelper.d(tag, "FindNextComponentBlocEvent");
      final allComponents = AllComponents.widgets;
      final activeIndex = allComponents.indexWhere((component) => component.id == state.activeComponent.id);

      if (activeIndex == -1) {
        emit(UpdateActiveComponentSuccess(
          activeComponent: allComponents.first,
          allComponents: state.allComponents,
          activeCategory: state.activeCategory,
        ));
        return;
      }
      if (event.isNext && activeIndex < allComponents.length - 1) {
        emit(UpdateActiveComponentSuccess(
          activeComponent: allComponents[activeIndex + 1],
          allComponents: state.allComponents,
          activeCategory: state.activeCategory,
        ));
        return;
      }
      if (!event.isNext && activeIndex > 0) {
        emit(UpdateActiveComponentSuccess(
          activeComponent: allComponents[activeIndex - 1],
          allComponents: state.allComponents,
          activeCategory: state.activeCategory,
        ));
        return;
      }
    });
  }
}
