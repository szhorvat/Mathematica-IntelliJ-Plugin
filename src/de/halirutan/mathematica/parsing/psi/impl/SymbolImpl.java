/*
 * Copyright (c) 2013 Patrick Scheibe
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package de.halirutan.mathematica.parsing.psi.impl;

import com.intellij.lang.ASTNode;
import com.intellij.openapi.util.TextRange;
import com.intellij.psi.PsiElement;
import com.intellij.psi.PsiReference;
import de.halirutan.mathematica.parsing.psi.api.Symbol;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

/**
 * @author patrick (3/28/13)
 */
public class SymbolImpl extends ExpressionImpl implements Symbol {

  public SymbolImpl(@NotNull ASTNode node) {
    super(node);
  }


  @Override
  public PsiElement setName(@NonNls @NotNull String name) {
    return MathematicaPsiUtililities.setSymbolName(this, name);
  }

  @Override
  public String getName() {
    return MathematicaPsiUtililities.getSymbolName(this);
  }

  @Override
  public String getMathematicaContext() {
    String myName = MathematicaPsiUtililities.getSymbolName(this);
    String context;
    if (myName.contains("`")) {
      context = myName.substring(0, myName.lastIndexOf('`') + 1);
    } else {
      context = "System`";
    }
    return context;
  }

  @Override
  public String getSymbolName() {
    String myName = MathematicaPsiUtililities.getSymbolName(this);
    if (myName.lastIndexOf('`') == -1) {
      return myName;
    } else {
      return myName.substring(myName.lastIndexOf('`') + 1, myName.length());
    }
  }

  @Nullable
  @Override
  public PsiElement getNameIdentifier() {
    return this.getNode().getPsi();
  }

  @Override
  public PsiReference getReference() {
    return new SymbolPsiReference(this, TextRange.from(0, getFirstChild().getTextLength()));
  }
}