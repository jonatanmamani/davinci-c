/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package edu.davinci.ui.editor.autocompletado;

import org.fife.ui.autocomplete.CompletionProvider;
import org.fife.ui.autocomplete.TemplateCompletion;

/**
 *
 * @author dany
 */
public class AutoCompletarPrimitiva extends TemplateCompletion{

    //
    public static final String PREFIJO="";
    
    //
    public static final String SUFIJO=" :: Primitiva";
    /**
     * 
     * @param provider
     * @param inputText
     * @param definitionString
     * @param template 
     */
    public AutoCompletarPrimitiva(CompletionProvider provider, String inputText, String definitionString, String template) {
        super(provider, inputText, definitionString, template);
    }
    
    /**
     * 
     * @param provider
     * @param inputText
     * @param definitionString
     * @param template
     * @param shortDescription
     * @param summary 
     */
    public AutoCompletarPrimitiva(CompletionProvider provider, String inputText, String definitionString, String template,String shortDescription, String summary){
        super(provider, inputText, definitionString, template, shortDescription, summary);
    }
}
