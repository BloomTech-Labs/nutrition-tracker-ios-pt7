//
//  BottomSheetModal.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//


import SwiftUI

struct BottomSheetModal<Content: View>: View {

  private let modalHeight: CGFloat = 430
  private let modalWidth: CGFloat = UIScreen.main.bounds.width
  private let modalCornerRadius: CGFloat = 30
  private let backgroundOpacity = 0.65
  private let dragIndicatorVerticalPadding: CGFloat = 20

  @State private var offset = CGSize.zero
  @Binding var display: Bool

  var content: () -> Content

  var body: some View {
    ZStack(alignment: .bottom) {
      if display {
        background.onTapGesture {
            if self.display {
                self.display = false
            }
        }
        modal
      }
    }
    .edgesIgnoringSafeArea(.all)
  }

  private var background: some View {
    Color(UIColor(named: "bottom-sheet-modal-bg")!)
      .fillParent()
      .opacity(backgroundOpacity)
      .animation(.spring())
  }

  private var modal: some View {
    VStack {
      indicator
      self.content()
    }
    .frame(width: modalWidth, height: modalHeight, alignment: .top)
    .background(Color(UIColor(named: "bubble-bg-color")!))
    .cornerRadius(modalCornerRadius)
    .offset(y: offset.height)
    .gesture(
      DragGesture()
        .onChanged { value in self.onChangedDragValueGesture(value) }
        .onEnded { value in self.onEndedDragValueGesture(value) }
    )
    .transition(.move(edge: .bottom))
  }

  private var indicator: some View {
    DragIndicator()
      .padding(.vertical, dragIndicatorVerticalPadding)
  }

  private func onChangedDragValueGesture(_ value: DragGesture.Value) {
    guard value.translation.height > 0 else { return }
    self.offset = value.translation
  }

  private func onEndedDragValueGesture(_ value: DragGesture.Value) {
    guard value.translation.height >= self.modalHeight / 2 else {
      self.offset = CGSize.zero
      return
    }

    withAnimation {
      self.display.toggle()
      self.offset = CGSize.zero
    }
  }
}

struct DragIndicator: View {
  private let width: CGFloat = 40
  private let height: CGFloat = 6
  private let cornerRadius: CGFloat = 3

  var body: some View {
    Rectangle()
      .fill(Color(UIColor(named: "bg-color")!))
      .frame(width: width, height: height)
      .cornerRadius(cornerRadius)
  }
}

struct BottomSheetModal_Previews: PreviewProvider {
    static var previews: some View {
      BottomSheetModal(display: .constant(true)) {
        Text("Bottom Sheet Modal")
          .font(Font.system(.headline))
          .foregroundColor(Color.white)
      }
    }
}
